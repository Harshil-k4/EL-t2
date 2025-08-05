// Simple Express server for demonstration
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Root route: returns a friendly message
app.get('/', (req, res) => {
  res.send('Hello, thiss is HArshil Kumar, Elevate Labs DevOps Task 1');
});

// Start the server and log the port
app.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}`);
});
