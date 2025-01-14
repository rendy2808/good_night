# Good Night

## Requirements

To run this project, ensure you have the following installed:

- **Ruby**: Version specified in `.ruby-version` file
- **Rails**: Version specified in `Gemfile`
- **PostgreSQL**: Compatible with the specified Rails version

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/rendy2808/good_night.git
   cd your-repo
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Ensure PostgreSQL is running and properly configured.

## Database Setup

To set up the database:

1. Create the databases:

   ```bash
   rails db:create
   ```

2. Run migrations for the development database:

   ```bash
   rails db:migrate
   ```

3. Run migrations for the test database:

   ```bash
   rails db:migrate RAILS_ENV=test
   ```

## Usage

Start the Rails server:

```bash
rails server
```

Spec (TEST):
```bash
bundle exec rspec spec/
```

## CURLs

Below are examples of `curl` commands for interacting with the API:

### Follow a user

```bash
curl --location 'localhost:3000/api/v1/follow' \
--header 'x-api-key: key-12345' \
--header 'Content-Type: application/json' \
--data '{
    
        "user_id": 1,
        "follow_id": 2    
}'
```

### Unfollow a user

```bash
curl --location 'localhost:3000/api/v1/follow/unfollow' \
--header 'x-api-key: key-12345' \
--header 'Content-Type: application/json' \
--data '{
    
        "user_id": 99999,
        "follow_id": 2    
}'
```

### Clock in

```bash
curl --location 'localhost:3000/api/v1/clock_in' \
--header 'x-api-key: key-12345' \
--header 'Content-Type: application/json' \
--data '{
    
        "user_id": 3,
        "clock_in_type": "wake_up/good night"    
}'
```

### Get following record

```bash
curl --location 'localhost:3000/api/v1/clock_in/following_record?user_id=2' \
--header 'x-api-key: key-12345' \
--data ''
```

###
