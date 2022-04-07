import numpy
import pandas
import plotly.graph_objects as go
import plotly.io as pio

# read in the data to a dataframe
#data_path = 'C:/Costa_Rica/EFT/Landsat7/EFT_correspondence_table_NP_based_national_scale_percentages.xlsx'
#data_path = "C:/EFT/EFD/EFD_b4_w3_2001_2017_correspondence_table_NP_based_national_scale_percentages.xlsx"
data_path = "C:/EFT/EFD/EFD_b4_w3_2001_2017_correspondence_table_NP_based_national_scale_percentages_all.xlsx"
df = pandas.read_excel(
    data_path,
    sheet_name='EFD_b4_w3_2001_2017_corresponde',
    index_col=0  # use the first column as the row index
)


source_names = list(df.index.values)   # a list of the values in the first column
target_names = list(df.columns.values)  # a list of the values in the first row

# make all the source labels pink, and all the target labels blue
source_colors = ['rgba(255, 0, 255, 0.8)' for _ in source_names]
target_colors = ['rgba(23, 190, 207, 0.8)' for _ in target_names]
label_colors = source_colors + target_colors



# put all the source names and target names together in a list
labels = source_names + target_names
# this is the index where the target names start
targets_start_index = len(source_names)

sources = []
targets = []
values = []

# iterate over the rows in the dataframe in order
for source_index, (source, row) in enumerate(df.iterrows()):
    # source is a string
    # row is a pandas Series that we can iterate over
    for target_index, (target, value) in enumerate(row.iteritems()):
        # target is a string
        # value is the number in the cell or NaN
        if not numpy.isnan(value):  # don't include NaN cells
            # append the index, not the name. e.g. 0 instead of NP_CR_EFT111
            sources.append(source_index)
            targets.append(target_index + targets_start_index)
            values.append(value)

# print out all the source, target, value pairs
for s, t, v in zip(sources, targets, values):
    print(s, t, v)
    
# you can also do cool things with the colors, as an example:
# the fourth value of RGBA color is the opacity (0-1)
# you can use the value (the link width) to scale the opacity
link_colors = [f'rgba(44, 160, 44, {value})' for value in values]

# display the figure
fig = go.Figure(data=[go.Sankey(
    node=dict(
        pad=15,
        thickness=20,
        line=dict(color="black", width=0.5),
        label=labels,
        color=label_colors
    ),
    link=dict(
      source=sources,
      target=targets,
      value=values,
      #color=link_colors
      color='rgba(44, 160, 44, 0.5)'
    )
)])

fig.update_layout(title_text="Sankey Diagram", font_size=12,width=800, height=800)
fig.show()
#pio.write_image(fig, 'C:/EFT/Fig/EFD_b4_w3_Sankey_Diagram_from_National_Local.png')
#fig.write_image("C:/EFT/Fig/EFD_b4_w3_Sankey_Diagram_from_National_Local.svg")
#fig.write_html("C:/EFT/Fig/EFD_b4_w3_Sankey_Diagram_from_National_lLocal.html")