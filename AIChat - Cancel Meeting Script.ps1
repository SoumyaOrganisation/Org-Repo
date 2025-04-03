import jarvis_si

def cancel_meeting(meeting_id):
    cancellation = jarvis_si.cancel_meeting(meeting_id)
    return cancellation

meeting_id = "12345"

cancellation_details = cancel_meeting(meeting_id)
print(cancellation_details)
