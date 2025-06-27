
// Import the built-in 'http' module
const http = require('http');

// Define the server port
const PORT = 3001;

// Create the HTTP server
const server = http.createServer((req, res) => {
  res.statusCode = 200;                  // Set status code to 200 (OK)
  res.setHeader('Content-Type', 'text/plain');  // Set content type
  res.end('Hello, World!\n');            // Send the response
});

// Start the server
server.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
