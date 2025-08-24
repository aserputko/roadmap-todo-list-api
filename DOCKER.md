# Docker Setup for Todo List API

This document explains how to build and run the Todo List API using Docker.

## Prerequisites

- Docker installed on your system
- Database instance running (PostgreSQL, MySQL, or SQLite)

## Building the Docker Image

```bash
# Build the image
docker build -t todo-list-api .

# Or with a specific tag
docker build -t todo-list-api:latest .
```

## Running the Container

### Basic Run

```bash
docker run -d \
  --name todo-list-api \
  -p 3000:3000 \
  -e DB_HOST=your-db-host \
  -e DB_PORT=5432 \
  -e DB_USERNAME=your-username \
  -e DB_PASSWORD=your-password \
  -e DB_DATABASE=your-database \
  -e JWT_SECRET=your-jwt-secret \
  todo-list-api
```

### Using Environment File

1. Copy the example environment file:

   ```bash
   cp env.example .env
   ```

2. Edit `.env` with your actual database credentials

3. Run with environment file:
   ```bash
   docker run -d \
     --name todo-list-api \
     -p 3000:3000 \
     --env-file .env \
     todo-list-api
   ```

### Docker Compose (Recommended)

The project includes a `docker-compose.yml` file for easy development setup:

```bash
# Start the entire stack (API + Database)
docker-compose up -d

# Start only the API (if you have external database)
docker-compose up -d app

# View logs
docker-compose logs -f app
```

## Environment Variables

| Variable            | Description                             | Default    | Required |
| ------------------- | --------------------------------------- | ---------- | -------- |
| `DATABASE_HOST`     | Database host address                   | -          | Yes      |
| `DATABASE_PORT`     | Database port                           | 5432       | No       |
| `DATABASE_USERNAME` | Database username                       | -          | Yes      |
| `DATABASE_PASSWORD` | Database password                       | -          | Yes      |
| `DATABASE_NAME`     | Database name                           | -          | Yes      |
| `DATABASE_TYPE`     | Database type (postgres, mysql, sqlite) | postgres   | No       |
| `PORT`              | Application port                        | 3000       | No       |
| `NODE_ENV`          | Environment mode                        | production | No       |
| `JWT_SECRET`        | JWT signing secret                      | -          | Yes      |
| `JWT_EXPIRES_IN`    | JWT expiration time                     | 24h        | No       |

## Health Check

The container includes a health check that runs every 30 seconds:

```bash
# Check container health
docker ps

# View health check logs
docker logs todo-list-api
```

## Security Features

- **Non-root user**: The application runs as user `nestjs` (UID 1001)
- **Signal handling**: Uses `dumb-init` for proper signal handling
- **Multi-stage build**: Reduces final image size
- **Production dependencies only**: Excludes dev dependencies from final image

## Troubleshooting

### Container won't start

- Check if the database is accessible from the container
- Verify all required environment variables are set
- Check container logs: `docker logs todo-list-api`

### Database connection issues

- Ensure database host is accessible from Docker network
- Verify database credentials
- Check if database port is correct and open

### Permission issues

- The container runs as non-root user
- Ensure database user has proper permissions

## Production Considerations

- Use external database service (AWS RDS, Google Cloud SQL, etc.)
- Set strong JWT secrets
- Use environment-specific configuration
- Consider using Docker secrets for sensitive data
- Set up proper logging and monitoring
- Use reverse proxy (nginx) for SSL termination
