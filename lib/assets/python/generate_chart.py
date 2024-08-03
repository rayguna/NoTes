from bokeh.plotting import figure
from bokeh.embed import components

def generate_chart(data, year):
    # Data preparation
    months = ["January", "February", "March", "April", "May", "June", "July", 
              "August", "September", "October", "November", "December"]
    # Use provided data or fallback to dummy data
    if data:
        topic_counts = [int(count) for count in data.split(",")]
    else:
        # Dummy data for demonstration
        topic_counts = [5, 9, 15, 20, 25, 18, 30, 10, 5, 8, 12, 7]

    # Create a new plot with a title and axis labels
    p = figure(title=f"Number of Topics Created for {year}",
               x_axis_label='Month', y_axis_label='Number of Topics',
               x_range=months, width=800, height=400)  # Updated attributes

    # Add a line renderer with markers
    p.line(months, topic_counts, legend_label="Topics", line_width=2)
    p.circle(months, topic_counts, size=8, color='navy', alpha=0.5)

    # Get the components for embedding
    script, div = components(p)
    return script, div

if __name__ == "__main__":
    import sys
    data = sys.argv[1] if len(sys.argv) > 1 else None
    year = sys.argv[2] if len(sys.argv) > 2 else "2024"
    script, div = generate_chart(data, year)
    print(script)
    print(div)
