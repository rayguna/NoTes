import openai
import os
import sys
import re
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# Did you have to do this using python? 

# Set your OpenAI API key
openai.api_key = os.getenv('MY_GPT2_KEY')  # Ensure this environment variable is set correctly

def fetch_notes_by_topic_name(topic_name):
    """
    Fetch notes associated with a given topic name from the database.
    
    Args:
    topic_name (str): The name of the topic.
    
    Returns:
    str: A formatted string containing all notes associated with the topic.
    """
    # Mocked function to simulate fetching from the database
    # Replace this function with actual database queries in your Rails environment
    notes = [
        {"title": "Note 1", "content": "Content of note 1", "topic": "AI"},
        {"title": "Note 2", "content": "Content of note 2", "topic": "AI"},
        {"title": "Note 3", "content": "Content of note 3", "topic": "ML"},
        {"title": "Note 4", "content": "Content of note 4", "topic": "ML"}
    ]
    filtered_notes = [note for note in notes if note['topic'].lower() == topic_name.lower()]
    return "\n\n".join([f"Title: {note['title']}\nContent: {note['content']}" for note in filtered_notes])

def generate_word_cloud(text, output_image_path):
    """
    Generate a word cloud from the given text and save it to the specified output path.
    
    Args:
    text (str): The input text for generating the word cloud.
    output_image_path (str): The path to save the generated word cloud image.
    """
    wordcloud = WordCloud(width=800, height=400, background_color='white').generate(text)
    plt.figure(figsize=(10, 5))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.savefig(output_image_path, format='png')
    plt.close()

# Example usage
if __name__ == "__main__":
    topic_name = sys.argv[1] if len(sys.argv) > 1 else "AI"
    notes_text = fetch_notes_by_topic_name(topic_name)
    output_image_path = f'public/charts/word_cloud.png'
    generate_word_cloud(notes_text, output_image_path)
