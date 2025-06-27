const express = require('express');
const app = express();
const port = 3000;

app.set('view engine', 'ejs');
app.use(express.static('public'));

app.get('/', (req, res) => {
  const projects = [
    "Node.js Portfolio Site",
    "REST API with Express",
    "Penetration Testing Automation"
  ];
  res.render('index', { name: "Devik Jagani", projects });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
