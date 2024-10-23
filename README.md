# Task Management API

This is a Ruby on Rails-based Task Management API, which allows users to create, manage, and retrieve tasks with JWT-based authentication. It supports CRUD operations, pagination, and integration with PostgreSQL. The API is documented with Swagger UI.

## Features

- **JWT Authentication**: Secure login and token-based authentication.
- **PostgreSQL**: Uses PostgreSQL as the primary database.
- **RESTful API**: Standard CRUD routes for task management.
- **Pagination**: Fetch paginated tasks.
- **Swagger UI**: API documentation with Swagger.
- **CORS enabled**: Supports communication between backend and frontend.

## Prerequisites

- Ruby 3.3.0 or above
- Rails 7.0 or above
- PostgreSQL 12 or above
- Node.js and Yarn
- Postman (for testing APIs)

## Setup

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/task-management-api.git
    cd task-management-api
    ```

2. Install dependencies:

    ```bash
    bundle install
    yarn install
    ```

3. Create the database:

    Make sure PostgreSQL is installed and running. Then create and migrate the database.

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Setup environment variables:

    Generate Rails credentials for storing the JWT secret key and other sensitive information.

    ```bash
    EDITOR="nano" bin/rails credentials:edit
    ```

    Add the following:

    ```yaml
    jwt_secret: <your-secret-key>
    ```

5. Start the server:

    ```bash
    rails server
    ```

    The API will be available at `http://localhost:8080`.

## JWT Authentication

1. **Login**: Use the `/login` endpoint to authenticate and retrieve a JWT token.
   Example request (using Postman or cURL):

    ```bash
    POST /login
    Content-Type: application/json

    {
      "email": "admin@example.com",
      "password": "password123"
    }
    ```

2. **Protected Routes**: Pass the token in the Authorization header for accessing protected routes.

    ```bash
    Authorization: Bearer <your-jwt-token>
    ```

## API Endpoints

### Task Management Endpoints

- **GET /tasks**: Retrieve all tasks (paginated).
- **POST /tasks**: Create a new task.
- **GET /tasks/:id**: Retrieve a specific task by ID.
- **PUT /tasks/:id**: Update a task by ID.
- **DELETE /tasks/:id**: Delete a task by ID. (soft delete)

### Pagination

Use the `page` and `per_page` parameters to paginate the tasks.

Example:

```bash
GET /tasks?page=1&per_page=10
