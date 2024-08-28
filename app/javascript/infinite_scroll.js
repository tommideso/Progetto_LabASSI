document.addEventListener('DOMContentLoaded', () => {
    const menuList = document.getElementById('menu-list');
    let page = 1;
  
    const loadMore = () => {
      if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
        page += 1;
        fetch(`/menus?page=${page}`, {
          headers: { 'Accept': 'text/vnd.turbo-stream.html' }
        })
        .then(response => response.text())
        .then(html => Turbo.renderStreamMessage(html))
        .catch(error => console.error('Error loading more menus:', error));
      }
    };
  
    window.addEventListener('scroll', loadMore);
  });