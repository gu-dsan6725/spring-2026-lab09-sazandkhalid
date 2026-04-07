#!/usr/bin/env bash
# Alice Session 1: 5 conversation turns in the same session
set -e

BASE_URL="http://127.0.0.1:9090"

echo "=== Alice Session 1 ===" > alice_output.txt
echo "" >> alice_output.txt

# Turn 1
echo "User: Hi, I'm Alice. I'm a software engineer." >> alice_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "alice",
    "run_id": "alice-session-1",
    "query": "Hi, I'\''m Alice. I'\''m a software engineer."
  }' | jq -r '.response')
echo "Agent: $response" >> alice_output.txt
echo "" >> alice_output.txt

# Turn 2
echo "User: I prefer Python for development." >> alice_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "alice",
    "run_id": "alice-session-1",
    "query": "I prefer Python for development."
  }' | jq -r '.response')
echo "Agent: $response" >> alice_output.txt
echo "" >> alice_output.txt

# Turn 3
echo "User: What programming languages do I like?" >> alice_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "alice",
    "run_id": "alice-session-1",
    "query": "What programming languages do I like?"
  }' | jq -r '.response')
echo "Agent: $response" >> alice_output.txt
echo "" >> alice_output.txt

# Turn 4
echo "User: I'm working on a FastAPI project." >> alice_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "alice",
    "run_id": "alice-session-1",
    "query": "I'\''m working on a FastAPI project."
  }' | jq -r '.response')
echo "Agent: $response" >> alice_output.txt
echo "" >> alice_output.txt

# Turn 5
echo "User: What have we discussed so far?" >> alice_output.txt
response=$(curl -s -X POST "$BASE_URL/invocation" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "alice",
    "run_id": "alice-session-1",
    "query": "What have we discussed so far?"
  }' | jq -r '.response')
echo "Agent: $response" >> alice_output.txt
echo "" >> alice_output.txt

echo "Alice Session 1 complete. Output saved to alice_output.txt"
