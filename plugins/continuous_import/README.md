The continuous import plugin lets Nikola work as a hub for the different
ways in which you put content out on the Internet. For example, you may
post book reviews in GoodReads, or movie reviews at a different site,
or have a Tumblr, or post links at Reddit.

Using continuous import you can have that content presented also in your own
site, making it the authoritative source for all things you write, and giving
you a backup in case those sites ever disappear.

TODO: explain how it works

```
# This is a list of feeds whose contents will be imported as posts into
# your blog via the "nikola continuous_import" command.

FEEDS = {
    'goodreads': {
        'url': 'https://www.goodreads.com/review/list_rss/1512608?shelf=read',
        'template': 'goodreads.tmpl',
        'output_folder': 'posts/goodreads',
        'format': 'html',
        'lang': 'en',
        'tags': 'books, goodreads',
        'metadata': {
            'title': 'title',
            'date': ['user_read_at', 'user_date_added', 'published'],
        }
    }
}

```
