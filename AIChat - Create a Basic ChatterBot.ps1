# Install ChatterBot library using pip
Start-Process -NoNewWindow -Wait -FilePath "python" -ArgumentList "-m pip install chatterbot"
# Import necessary libraries
Add-Type -AssemblyName System.Windows.Forms
$pythonCode = @"
from chatterbot import ChatBot
chatbot = ChatBot('Example Bot')
print('ChatterBot created successfully')
"@
# Execute Python code
python -c $pythonCode
