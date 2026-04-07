#!/usr/bin/env bash
# Carol Session 1: Demonstrates user isolation (separate memory space from Alice)
set -e

BASE_URL="http://127.0.0.1:9090"

echo "=== Carol Session 1 ===" > carol_output.txt
echo "" >> carol_output.txt

# Turn 1
echo "User: Hi, I'm Carol. I'm a data scientist." >> carol_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "carol",
    "run_id": "carol-session-1",
    "query": "Hi, I'\''m Carol. I'\''m a data scientist."
  }' | jq -r '.response')
echo "Agent: $response" >> carol_output.txt
echo "" >> carol_output.txt

# Turn 2
echo "User: What programming languages do I like?" >> carol_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "carol",
    "run_id": "carol-session-1",
    "query": "What programming languages do I like?"
  }' | jq -r '.response')
echo "Agent: $response" >> carol_output.txt
echo "" >> carol_output.txt

# Turn 3
echo "User: Do you know what Alice prefers?" >> carol_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "carol",
    "run_id": "carol-session-1",
    "query": "Do you know what Alice prefers?"
  }' | jq -r '.response')
echo "Agent: $response" >> carol_output.txt
echo "" >> carol_output.txt

echo "Carol Session 1 complete. Output saved to carol_output.txt"
