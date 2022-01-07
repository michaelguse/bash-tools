from plotly.subplots import make_subplots
import plotly.graph_objects as go
import pandas as pd

df = pd.read_csv('/Users/mguse/Google Drive/Workspaces/Salesforce/bash-tools/jwstTempFile.csv')

fig = make_subplots(rows=3, cols=1,
                    shared_xaxes=True,
                    vertical_spacing=0.05)

fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempWarmSide1C"], 
                mode='lines+markers', name="warmSide1C"), 
                row=1, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempWarmSide2C"], 
                mode='lines+markers', name="warmSide2C"),
              row=1, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempCoolSide1C"], 
                mode='lines+markers', name="coolSide1C"),
              row=1, col=1)
fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" tempCoolSide2C"], 
                mode='lines+markers', name="coolSide2C"),
              row=1, col=1)

fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" speedKmS"], 
                mode='lines+markers', name="JWST speed"),
              row=2, col=1)

fig.add_trace(go.Scatter(x=df["Timestamp"], y=df[" percentCompleted"], 
                mode='lines+markers', name="Journey to L2"),
              row=3, col=1)

fig.update_yaxes(title="Temperature [Celsius]", range=(-350,100), row=1, col=1)
fig.update_yaxes(title="Speed [km/s]", range=(0,0.6), row=2, col=1)
fig.update_yaxes(title="Trip Completed [%]", range=(60,100), row=3, col=1)

fig.update_xaxes(title="Date & Time [UTC]", row=3, col=1)

fig.update_layout(height=800, width=1200,
                  title_text="James Webb Space Telescope (JWST) REST API over time")

fig.show()


#import pandas as pd
#import plotly.express as px

#df = pd.read_csv('/Users/mguse/Google Drive/Workspaces/Salesforce/bash-tools/jwstTempFile.csv')
#
#fig = px.line(df, x = "Timestamp", y = [" tempWarmSide1C" ," tempWarmSide2C"," tempCoolSide1C" ," tempCoolSide2C"], markers = True, title = 'Different temperatures of JWST over Time')
#fig.show()
#
#fig2 = px.line(df, x = "Timestamp", y = [" speedKmS"], markers = True, title = 'Speed of JWST over Time')
#fig2.show()
#
#fig3 = px.line(df, x = "Timestamp", y = [" percentCompleted"], markers = True, title = 'Completion of JWST journey to L2')
#fig3.show()

