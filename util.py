import pandas as pd
import numpy as np
import math

def write_sql_insert_file(file_name, df, table_name):    
    insert_queries = []
    with open(file_name, 'w', encoding='utf-8') as f:
        for index, row in df.iterrows():
            insert_query = f"INSERT INTO {table_name} ("
            for column_name in df.columns:
                insert_query += f" {column_name},"
            # Remove comma
            insert_query = insert_query[:-1] + ") VALUES ("
            for column_name in df.columns:
                value = row[column_name]
                if isinstance(value, str):
                    # Check if the value contains a single quote, and if so, escape it by adding another single quote
                    value = value.replace("'", "''")
                    insert_query += f" '{value}',"
                elif pd.isna(value) or np.isnan(value) or math.isnan(value):
                    insert_query += " NULL,"
                else:
                    insert_query += f" {value},"
            # Remove comma
            insert_query = insert_query[:-1] + ");\n"
            f.write(insert_query)