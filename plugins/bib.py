from nikola.plugin_categories import ShortcodePlugin

from pybtex.database.input.bibtex import Parser
from pybtex.database import BibliographyData, PybtexError
from pybtex.backends import html
from pybtex.style.formatting import BaseStyle, plain
        

class Bibtex(ShortcodePlugin):
    '''Provides bibliography-related shortcodes:
    - {{%reference *key* %}}
      includes the reference given its key
    - {{%bibliography [sort=by=*[-]f*, *[-]f*,...] [group-by=*f*] [category=*c*]%}}
      includes a bibliography that can be sorted by a number of fields (in reverse order
      if preceded by a -) and grouped by another field 
    '''

    # ---------- Registration ----------
    
    def set_site(self, site):
        '''Set the Nikola site object, extracting any configuration.

        :param site: the site'''
        self._site = site

        # read in Bibtex file
        self._bibfile = site.config['BIBFILE']
        try:
            p = Parser()
            self._bibdata = p.parse_file(self._bibfile)
        except PybtexError as e:
            raise self.error('Error parsing {fn} ({e})'.format(fn= self._bibfile, e=str(e)))

        # use the plain style for now
        self._style = plain.Style()

        # use the HTML backend
        self._backend = html.Backend()

        # register the shortcodes
        self._site.register_shortcode('reference', self.reference)
        self._site.register_shortcode('bibliography', self.bibliography)


    # ---------- Helper methods ----------
    
    def _layout(self, key):
        '''Lay out a single reference given its key.

        :param: the reference's key in the reference database
        :returns: the reference'''
        return self._layoutEntry(self._bibdata.entries[key])

    def _layoutEntry(self, entry):
        '''Lay out a single reference.

        :param: the reference's database entry
        :returns: the reference'''
        f = self._style.format_entry('', entry)
        return f.text.render(self._backend)

    
    # ---------- Shortcode handlers ----------
    
    def reference(self, key, **kwds):
        '''Include the reference with the given key, laid-out in the current style.

        :param key: the key
        :returns: the reference's text and dependencies'''
        return (self._layout(key), [ self._bibfile ])

    def bibliography(self, **kwds):
        '''Include the bibliography, laid-out in the current style.

        :param key: the key
        :param sort-by: (optional) comma-separated list of fields to sort, reversed if preceded by -
        :param group-by: (optional) grouping of references
        :returns: the bibliography and dependencies'''
        entries = self._bibdata.entries.values()

        # extract category (if specified)
        if 'category' in kwds.keys():
            category = kwds['category']
            es = []
            for e in entries:
                if 'category' in e.fields.keys():
                    cs = [ c.strip() for c in e.fields['category'].split(',') ]
                    if category in cs:
                        es.append(e)
            entries = es
            
        # sort entries by fields (if specified)
        if 'sort-by' in kwds.keys():
            fields = kwds['sort-by'].split(',')
            order = []
            for i in range(len(fields)):
                if fields[i][0] == '-':
                    order.append(True)
                    fields[i] = fields[i][1:]
                else:
                    if fields[i][0] == '+':
                        order.append(False)
                        fields[i] = fields[i][1:]
                    else:
                        order.append(False)

            # restrict to entries that have all the fields
            es = []
            for e in entries:
                for f in fields:
                    if f not in e.fields.keys():
                        continue
                es.append(e)
            entries = es

            # sort the entries
            for i in range(len(fields) - 1, -1, -1):
                entries.sort(key=lambda e: e.fields.get(fields[i], ''), reverse=order[i])

        # emit in groups (if specified)
        if 'group-by' in kwds.keys():
            group = kwds['group-by']
            entry = entries[0]
            g = entry.fields.get(group, '')
            groups = dict()
            groups[g] = [ entry ]
            for entry in entries[1:]:
                h = entry.fields.get(group, '')
                if g == h:
                    groups[g].append(entry)
                else:
                    groups[h] = [ entry ]
                    g = h

            doc = ''
            for g in groups.keys():
                doc += '<h2>{g}</h2>'.format(g=g)
                for entry in groups[g]:
                    doc += '<p>' + self._layoutEntry(entry)

        # no grouping, emit the bibliography in one go
        else:
            doc = ''
            for entry in entries:
                doc += '<p>' + self._layoutEntry(entry)
        
        return (doc, [ self._bibfile ])
    

