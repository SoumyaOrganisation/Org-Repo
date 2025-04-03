# Import necessary libraries
Add-Type -AssemblyName System.Windows.Forms
$pythonCode = @"
from chatterbot import ChatBot

chatbot = ChatBot(
    'SQLBot',
    storage_adapter='chatterbot.storage.SQLStorageAdapter',
    database_uri='sqlite:///database.sqlite3'
)
print('ChatterBot with SQL storage created successfully')
"@
# Execute Python code
python -c $pythonCode
