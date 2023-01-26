from plotly.subplots import make_subplots
import plotly.graph_objects as go
import pandas as pd

df = pd.read_csv('/Users/mguse/Documents/workspaces/Salesforce/bash-tools/jwstTempFile.csv')

fig = make_subplots(rows=4, cols=1,
                    shared_xaxes=True,
                    vertical_spacing=0.05)

fig.update_layout(width=1200,
                  title_text="James Webb Space Telescope (JWST) REST API over time")

fig.update_yaxes(title="Temp [Celsius]", row=1, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempWarmSide1C"], 
                mode='lines+markers', name="warmSide1C", line_color="red"), 
                row=1, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempWarmSide2C"], 
                mode='lines+markers', name="warmSide2C", line_color="orange"),
              row=1, col=1)

fig.update_yaxes(title="Temp [Celsius]", row=2, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempCoolSide1C"], 
                mode='lines+markers', name="coolSide1C", line_color="blue"),
              row=2, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempCoolSide2C"], 
                mode='lines+markers', name="coolSide2C", line_color="purple"),
              row=2, col=1)

fig.update_yaxes(title="Speed [km/s]", row=3, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" speedKmS"], 
                mode='lines+markers', name="JWST speed"),
              row=3, col=1)

fig.update_yaxes(title="Trip Completed [%]", row=4, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" percentCompleted"], 
                mode='lines+markers', name="Journey to L2"),
              row=4, col=1)
fig.update_xaxes(title="Date & Time [UTC]", row=4, col=1)

fig.show()
