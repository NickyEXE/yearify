document.getElementById('generate').addEventListener("click", () => {
  alert(`<h3>Your playlists are being generated. Please check back in an hour or so. Feel free to leave the page.</h3>`)
})

document.getElementById('destroy-all').addEventListener("click", () => {
  document.querySelector("ul").outerHTML = `<h3>Your playlists are being destroyed. This may take a little bit. Feel free to leave the page.</h3>`
})
