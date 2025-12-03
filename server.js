// Import required modules
const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const client = require("prom-client");
const winston = require("winston");
const LokiTransport = require("winston-loki");

const app = express();
const PORT = 8000;

app.use(bodyParser.json());

// ---------------------------------
// LOKI LOGGER (Winston)
// ---------------------------------
const logger = winston.createLogger({
  transports: [
    new LokiTransport({
      host: "http://172.29.98.150:3100",
      labels: { job: "nodejs-app" },
      json: true,
      replaceTimestamp: true,
    }),
  ],
});

// ---------------------------------
// PROMETHEUS METRICS
// ---------------------------------
const register = new client.Registry();
client.collectDefaultMetrics({ register });

// Count total HTTP requests
const httpRequestCounter = new client.Counter({
  name: "http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "route"],
});
register.registerMetric(httpRequestCounter);

// Count status codes
const httpResponseStatusCounter = new client.Counter({
  name: "http_response_status_total",
  help: "Total number of responses by HTTP status",
  labelNames: ["status_code"],
});
register.registerMetric(httpResponseStatusCounter);

// Custom user metrics
const userCreatedCounter = new client.Counter({
  name: "users_created_total",
  help: "Total number of users created",
});
register.registerMetric(userCreatedCounter);

const totalUsersGauge = new client.Gauge({
  name: "users_count",
  help: "Current number of users",
});
register.registerMetric(totalUsersGauge);

// ---------------------------------
// REQUEST LOGGING + METRICS MIDDLEWARE
// ---------------------------------
app.use((req, res, next) => {
  const route = req.path;

  res.on("finish", () => {
    logger.info("HTTP Request", {
      method: req.method,
      route,
      status_code: res.statusCode,
    });

    // Update metrics
    httpRequestCounter.inc({ method: req.method, route });
    httpResponseStatusCounter.inc({ status_code: res.statusCode });
  });

  next();
});

// ---------------------------------
// IN-MEMORY USER STORE
// ---------------------------------
let users = [
  { id: 1, name: "Alice", email: "alice@example.com" },
  { id: 2, name: "Bob", email: "bob@example.com" },
];

totalUsersGauge.set(users.length);

// ---------------------------------
// METRICS ENDPOINT
// ---------------------------------
app.get("/metrics", async (req, res) => {
  res.setHeader("Content-Type", register.contentType);
  res.send(await register.metrics());
});

// ---------------------------------
// STATIC UI
// ---------------------------------
app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

// ---------------------------------
// USERS API
// ---------------------------------

// GET all users
app.get("/users", (req, res) => {
  res.json(users);
});

// GET user by ID
app.get("/users/:id", (req, res) => {
  const user = users.find((u) => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ message: "User not found" });
  res.json(user);
});

// POST new user
app.post("/users", (req, res) => {
  const { name, email } = req.body;
  const newUser = { id: users.length + 1, name, email };

  users.push(newUser);
  userCreatedCounter.inc();
  totalUsersGauge.set(users.length);

  res.status(201).json(newUser);
});

// PUT update user
app.put("/users/:id", (req, res) => {
  const user = users.find((u) => u.id === parseInt(req.params.id));
  if (!user) return res.status(404).json({ message: "User not found" });

  const { name, email } = req.body;
  if (name) user.name = name;
  if (email) user.email = email;

  res.json(user);
});

// DELETE user
app.delete("/users/:id", (req, res) => {
  users = users.filter((u) => u.id !== parseInt(req.params.id));
  totalUsersGauge.set(users.length);

  res.json({ message: "User deleted" });
});

// ---------------------------------
// START SERVER
// ---------------------------------
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running at http://0.0.0.0:${PORT}`);
  logger.info(`Server running at http://0.0.0.0:${PORT}`);
});
