import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from urllib.request import urlopen
from bs4 import BeautifulSoup

url = "https://www.bodybuilding.com/recipes/the-college-boy"
html = urlopen(url)
soup = BeautifulSoup(html, 'html.parser')
text = soup.prettify()
print(text)
