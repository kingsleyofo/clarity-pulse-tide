# PulseTide
A decentralized application for monitoring live events and capturing real-time audience feedback.

## Features
- Create and manage events with titles and descriptions
- Update event metadata
- Deactivate events when completed
- Submit real-time feedback
- Track audience sentiment with weighted scoring
- View historical event data
- Prevent feedback on inactive events

## Architecture
The smart contract implements:
- Event management (creation, updates, deactivation)
- Feedback submission with validation
- Weighted scoring system
- Participant tracking
- Historical data storage

## Smart Contract Functions
### Administrative Functions
- create-event: Create new events with title and description
- update-event: Update existing event metadata
- deactivate-event: Deactivate completed events

### User Functions
- submit-feedback: Submit ratings for active events
- get-event: View event details
- get-event-rating: Get current event rating
- get-user-feedback: View user's submitted feedback
