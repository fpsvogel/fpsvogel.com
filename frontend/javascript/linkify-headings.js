document.addEventListener("turbo:load", linkifyHeadings)

/* Adds anchor links to headings. */
function linkifyHeadings(_event) {
  const headings = document.querySelectorAll("h2[id], h3[id], h4[id], h5[id], h6[id]");

  for (const heading of headings) {
    heading.innerHTML =
      '<a href="#' + heading.id + '">' +
          heading.innerText +
      '</a>';
  }
}