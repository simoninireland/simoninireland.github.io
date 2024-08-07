// Function to share page to Mastodon
// See https://www.bentasker.co.uk/posts/documentation/general/adding-a-share-on-mastodon-button-to-a-website.html

function MastodonShare(e) {

    // Get the source text
    src = e.getAttribute("data-src");

    // Get the Mastodon domain
    domain = prompt("Enter your Mastodon domain", "mastodon.social");

    if (domain == "" || domain == null){
	return;
    }

    // Build the URL
    url = "https://" + domain + "/share?text=" + src;

    // Open a window on the share page
    window.open(url, '_blank');
}
