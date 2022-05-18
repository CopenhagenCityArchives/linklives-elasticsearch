# Wait for elasticsearch to start
echo "Waiting 60 seconds"
sleep 60

# Create repository
echo "Creating repository"
curl -X PUT http://ll-es:9200/_snapshot/s3_repository -H "Content-Type: application/json" \
    -d "{ 
            \"type\": \"s3\", \"settings\": {
                \"bucket\": \"link-lives-elasticsearch-snapshots\" 
            }
        }"

# Restore "latest" snapshot
echo "Restoring snapshot"
curl -X POST http://ll-es:9200/_snapshot/s3_repository/latest/_restore -H "Content-Type: application/json" -d "{ \"indices\":\"sources*,pas*,transcribed*,lifecourses*\" }"

echo "All done"