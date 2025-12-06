import json

# Read the file with fn → Cmd+Ctrl+Alt (no shift)
with open('hyper-no-shift.json', 'r') as f:
    data = json.load(f)

# Get existing manipulators (these handle fn+key → Cmd+Ctrl+Alt+key)
original = data['rules'][0]['manipulators']
new_manipulators = []

# For each key mapping, create TWO rules:
# 1. Keep original: fn+key → Cmd+Ctrl+Alt+key
# 2. Add shifted version: fn+shift+key → Cmd+Ctrl+Alt+Shift+key
for m in original:
    # Rule 1: fn+key (no shift) - keep as-is
    new_manipulators.append(m)
    
    # Rule 2: fn+shift+key (with shift)
    shifted = json.loads(json.dumps(m))  # Deep copy to avoid mutating original
    
    # Add "shift" to the FROM modifiers (what you press)
    shifted['from']['modifiers']['mandatory'].append('shift')
    
    # Add "left_shift" to the TO modifiers (what gets sent)
    shifted['to'][0]['modifiers'].append('left_shift')
    
    new_manipulators.append(shifted)

# Replace manipulators with the expanded list
data['rules'][0]['manipulators'] = new_manipulators

# Update title
data['title'] = "fn to Hyper (Complete with Shift support)"
data['rules'][0]['description'] = "fn+key = Cmd+Ctrl+Alt+key, fn+shift+key = Cmd+Ctrl+Alt+Shift+key"

# Write the new file
with open('hyper-complete.json', 'w') as f:
    json.dump(data, f, indent=2)

print("✅ Created hyper-complete.json!")
print("Original rules:", len(original))
print("New rules:", len(new_manipulators))
