# Handicraft Backend

Node.js/Express backend with MongoDB for the Handicraft Online Store app.

## Prerequisites

- **Node.js** (v16+)
- **MongoDB** – Uses MongoDB Atlas (cloud) by default. No local MongoDB needed.

## Setup

1. **Install dependencies**
   ```bash
   cd backend
   npm install
   ```

2. **MongoDB connection**
   - The backend uses **MongoDB Atlas** (`mongodb+srv://...`).
   - To use **local MongoDB**, edit `server.js` and set:
     ```js
     const MONGO_URI = 'mongodb://127.0.0.1:27017/handicraft_store';
     ```
   - Ensure MongoDB is running locally if you use the above.

## Run

```bash
npm start
```

Or with auto-reload during development:

```bash
npm run dev
```

Server runs at: **http://localhost:3000**

## API Endpoints

| Method | Endpoint        | Description          |
|--------|-----------------|----------------------|
| POST   | /api/register   | Create new user      |
| POST   | /api/login      | Login (returns token + user) |
| GET    | /api/users      | List users (debug)   |

## Flutter app connection

- **Android Emulator**: Uses `http://10.0.2.2:3000/api` (maps to localhost)
- **Web**: Uses `http://localhost:3000/api`

Ensure the backend is running before testing login/signup in the Flutter app.
