import openai
import os
import sys
import re
from collections import defaultdict

# Set your OpenAI API key
openai.api_key = os.getenv('MY_GPT2_KEY')  # Ensure this environment variable is set correctly

# Preprocess notes data for efficient lookup
notes_data = [
    {"title": "Note 1", "content": "Content of note 1", "topic": "AI"},
    {"title": "Note 2", "content": "Content of note 2", "topic": "AI"},
    {"title": "Note 3", "content": "Content of note 3", "topic": "ML"},
    {"title": "Note 4", "content": "Content of note 4", "topic": "ML"}
]

# Create a dictionary for quick topic lookup
notes_by_topic = defaultdict(list)
for note in notes_data:
    notes_by_topic[note['topic'].lower()].append(f"Title: {note['title']}\nContent: {note['content']}")

def fetch_notes_by_topic_name(topic_name):
    """
    Fetch notes associated with a given topic name from preprocessed data.
    
    Args:
    topic_name (str): The name of the topic.
    
    Returns:
    str: A formatted string containing all notes associated with the topic.
    """
    topic_name = topic_name.lower()
    if topic_name in notes_by_topic:
        return "\n\n".join(notes_by_topic[topic_name])
    return "No matching topics found."

def answer_question(input_text, user_question):
    """
    Function to answer a question based on the provided input text using OpenAI API.
    
    Args:
    input_text (str): The text block to use as the context.
    user_question (str): The question to be answered based on the input text.
    
    Returns:
    str: The response from the OpenAI model.
    """
    try:
        # Check if the user question pertains to a topic name
        topic_name_match = re.search(r'\btopic:?\s*(\w+)', user_question, re.IGNORECASE)
        if topic_name_match:
            topic_name = topic_name_match.group(1)
            input_text = fetch_notes_by_topic_name(topic_name)
        
        # Create a chat completion request to OpenAI using the gpt-4 model
        response = openai.ChatCompletion.create(
            model="gpt-4",
            messages=[
                {"role": "system", "content": "You are a helpful assistant that answers questions based on the provided text. If the question is outside the scope of the provided text, respond with: 'Your question is outside the scope of the data.'"},
                {"role": "user", "content": f"Here is the context: {input_text}"},
                {"role": "user", "content": f"Question: {user_question}"}
            ]
        )

        # Extract the message content from the response
        response_content = response['choices'][0]['message']['content']
        return response_content
    except Exception as e:
        return f"An error occurred: {str(e)}"

# Example usage
if __name__ == "__main__":
    if len(sys.argv) > 2:
        user_question = str(sys.argv[1])
        input_text = str(sys.argv[2])
    else:
        user_question = "No question provided."
        input_text = "No input text provided."

    # Get the answer to the question based on the provided text
    response = answer_question(input_text, user_question)
    print(response)
