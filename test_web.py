import requests
import time

def query_agentic_seek(question):
    response = requests.post(
        'http://localhost:8000/query',
        json={"query": question, "tts_enabled": False}
     )
    
    if response.status_code == 429:
        print("Rate limited, waiting...")
        time.sleep(5)  # Wait 5 seconds
        return query_agentic_seek(question)  # Try again
        
    result = response.json()
    return result

# Example usage
answer = query_agentic_seek("What is your name?")
print(answer)
