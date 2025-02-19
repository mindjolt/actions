import os
import json

# Clear empty objects from the index
def remove_empty(obj):
    if isinstance(obj, dict):
        return {k: remove_empty(v) for k, v in obj.items() if v or isinstance(v, (int, float, bool))}
    elif isinstance(obj, list):
        return [remove_empty(v) for v in obj if v or isinstance(v, (int, float, bool))]
    return obj

def find_packages(base_dir):
    index = {"packages": {}}
    
    for root, dirs, files in os.walk(base_dir):
        if "package.json" in files:
            rel_path = os.path.relpath(root, base_dir)
            parts = rel_path.split(os.sep)
            
            if len(parts) < 2:
                continue  # Skip if path does not match expected structure
            
            package_name, package_version = parts[0], parts[1]
            package_json_path = os.path.join(root, "package.json")
            
            with open(package_json_path, "r", encoding="utf-8") as f:
                package_data = json.load(f)
            
            if package_name not in index["packages"]:
                index["packages"][package_name] = {}
            
            index["packages"][package_name][package_version] = package_data
    
    return remove_empty(index)

def save_index(index, output_path):
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(index, f, separators=(',', ':'), ensure_ascii=False)

def main():
    base_dir = "packages"  # Adjust if necessary
    output_file = "packages/index.json"
    index = find_packages(base_dir)
    save_index(index, output_file)
    print(f"Index saved to {output_file}")

if __name__ == "__main__":
    main()
