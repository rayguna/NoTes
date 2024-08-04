import plotly.graph_objects as go
import plotly.io as pio

def generate_chart(data, year):
    # Data preparation
    months = ["January", "February", "March", "April", "May", "June", "July", 
              "August", "September", "October", "November", "December"]

    # Use provided data or fallback to dummy data
    topic_counts = [int(count) for count in data.split(",")] if data else [0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0]

    # Create a Plotly figure
    fig = go.Figure()

    # Add a line plot with markers
    fig.add_trace(go.Scatter(x=months, y=topic_counts, mode='lines+markers', name='Topics'))

    # Update the layout
    fig.update_layout(
        title=f"Number of Topics Created for {year}",
        xaxis_title='Month',
        yaxis_title='Number of Topics',
        width=800,
        height=400
    )

    # Get the HTML components
    plot_html = pio.to_html(fig, full_html=False)

    return plot_html

if __name__ == "__main__":
    import sys
    data = sys.argv[1] if len(sys.argv) > 1 else None
    year = sys.argv[2] if len(sys.argv) > 2 else "2024"
    plot_html = generate_chart(data, year)
    print(plot_html)
