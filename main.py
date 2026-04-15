import os

# Current directory (change if needed)
folder_path = "."

for root, dirs, files in os.walk(folder_path):
    for filename in files:
        if filename.endswith(".svg.import"):
            file_path = os.path.join(root, filename)
            
            try:
                os.remove(file_path)
                print(f"Deleted: {file_path}")
            except Exception as e:
                print(f"Error deleting {file_path}: {e}")