module.exports = function(app, obj) {
  app.get("/", function(req, res) {
    res.render("master", {config: obj});
  });
}