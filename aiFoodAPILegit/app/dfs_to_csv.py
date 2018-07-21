import pandas as pd

df = pd.read_csv('/Users/shiningsunnyday/Desktop/Food/ingredients.csv')
train = pd.read_json('/Users/shiningsunnyday/Desktop/Food/train.json')
ingredients = []; count = {}

for recipe in train.values:
            
    for ingredient in recipe[2]:
        
        if ingredient not in ingredients:
            ingredients.append(ingredient)
            count[ingredient] = 0
        else:
            count[ingredient] += 1
            
dfs = df.loc[:, 'Ingredients':].dropna()
            
new_count = {x: count[x] for x in count.keys() if count[x] > 10}

dfs = dfs[dfs.Ingredients.isin(new_count.keys())]
dfs = dfs.reset_index().loc[:, 'Ingredients':]

dfs.to_csv(path_or_buf = '/Users/shiningsunnyday/Desktop/dfs_clean.csv')
