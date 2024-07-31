import sys
import matplotlib.pyplot as plt
from datetime import datetime

def generate_chart(data, year):
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    topic_counts = [int(count) for count in data.split(",")]

    plt.figure(figsize=(10, 5))
    plt.plot(months, topic_counts, marker='o', linestyle='-', color='b')
    plt.title(f'Number of Topics for {year}')
    plt.xlabel('Month')
    plt.ylabel('Number of Topics')
    plt.grid(True)
    plt.xticks(rotation=45)
    plt.tight_layout()

    image_path = f'/path/to/save/directory/topics_{year}.png'
    plt.savefig(image_path)
    plt.close()
    return image_path

if __name__ == "__main__":
    data = sys.argv[1]
    year = sys.argv[2]
    print(generate_chart(data, year))
