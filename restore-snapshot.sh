# Wait for elasticsearch to start
echo "Waiting 60 seconds"
sleep 60

# Create repository
echo "Creating or updating repository"
curl -X PUT http://ll-es:9200/_snapshot/s3_repository -H "Content-Type: application/json" \
    -d "{ 
            \"type\": \"s3\", \"settings\": {
                \"bucket\": \"link-lives-elasticsearch-snapshots\" 
            }
        }"

echo "Loading transcribed snapshots"
v=$(curl -X GET http://ll-es:9200/_snapshot/s3_repository/transcribed* | jq .snapshots[-1].snapshot)

# Restore "latest" snapshot
echo "Restoring latest transcribed snapshot"
curl -X POST http://ll-es:9200/_snapshot/s3_repository/${v//\"/}/_restore -H "Content-Type: application/json" -d "{ \"indices\":\"transcribed*\" }"

unset v

echo "Loading pas, lifecourses and sources snapshots"
v=$(curl -X GET http://ll-es:9200/_snapshot/s3_repository/pas_lifecourses_sources* | jq .snapshots[-1].snapshot)

# Restore "latest" snapshot
echo "Restoring latest lifecourses and sources snapshot"
curl -X POST http://ll-es:9200/_snapshot/s3_repository/${v//\"/}/_restore -H "Content-Type: application/json" -d "{ \"indices\":\"pas*,sources*,lifecourses*\" }"

unset v

echo "All done"