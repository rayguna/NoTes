import openai
import os
import sys
import re

# Set your OpenAI API key
openai.api_key = os.getenv('MY_GPT2_KEY')  # Ensure this environment variable is set correctly

def fetch_notes_by_topic_name(topic_name, input_text):
    """
    Fetch notes associated with a given topic name from the input text.
    
    Args:
    topic_name (str): The name of the topic.
    input_text (str): The input text containing notes.
    
    Returns:
    str: A formatted string containing all notes associated with the topic.
    """
    notes_pattern = re.compile(r"Title: (.*?)\nContent: (.*?)\nTopic: (.*?)\n\n", re.DOTALL)
    notes = notes_pattern.findall(input_text)
    filtered_notes = [f"Title: {title}\nContent: {content}" for title, content, topic in notes if topic.lower() == topic_name.lower()]
    
    # Return an empty string if no notes are found
    return "\n\n".join(filtered_notes) if filtered_notes else ""

def answer_question(input_text, user_question, question_scope):
    """
    Function to answer a question based on the provided input text using OpenAI API.
    
    Args:
    input_text (str): The text block to use as the context.
    user_question (str): The question to be answered based on the input text.
    question_scope (str): The scope of the question ('notes' or 'any').
    
    Returns:
    str: The response from the OpenAI model.
    """
    
    # try:
    #     input_text = input_text.lower()
    #     user_question = user_question.lower()
        
    #     if question_scope == "notes":
    #         # Check if the user question pertains to a topic name
    #         topic_name_match = re.search(r'\btopic:?\s*(\w+)', user_question, re.IGNORECASE)
    #         if topic_name_match:
    #             topic_name = topic_name_match.group(1)
    #             notes_content = fetch_notes_by_topic_name(topic_name, input_text)
                
    #             if not notes_content:
    #                 return "There is no data available to answer your question."

    #             input_text = notes_content
            
    #         # Create a chat completion request to OpenAI using the gpt-4 model
    #         response = openai.ChatCompletion.create(
    #             model="gpt-4",
    #             messages=[
    #                 {"role": "system", "content": "You are a helpful assistant that answers questions based on the provided text. If the question is outside the scope of the provided text, respond with: 'Your question is outside the scope of the data.'"},
    #                 {"role": "user", "content": f"Here is the context: {input_text}"},
    #                 {"role": "user", "content": f"Question: {user_question}"}
    #             ]
    #         )

    #         # Extract the message content from the response
    #         response_content = response['choices'][0]['message']['content']

    print("Feature is temporarily disabled. Return: ")

        elif question_scope == "any":
            response = openai.ChatCompletion.create(
                model="gpt-4",
                messages=[{"role": "user", "content": user_question}]
            )
            response_content = response['choices'][0]['message']['content']

        return response_content
    except Exception as e:
        return f"An error occurred: {str(e)}"

    #return print("This feature is temporarily disabled for monetary reason. Response: ")

# Example usage
if __name__ == "__main__":
    if len(sys.argv) > 3:
        user_question = str(sys.argv[1])
        input_text = str(sys.argv[2])
        question_scope = str(sys.argv[3])
    else:
        user_question = "No question provided."
        input_text = "No input text provided."
        question_scope = "any"

    # Get the answer to the question based on the provided text
    response = answer_question(input_text, user_question, question_scope)
    print(response)
