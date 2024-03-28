import os
import glob
import telegram
import asyncio

# Telegram bot token
TOKEN = 'TOKEN_HERE'
# Chat ID to send the photos
CHAT_ID = 'CHAT_ID_HERE'

# Folder containing the photos
FOLDER_PATH = 'FOLDER_PATH_HERE'

# Function to send photos to Telegram
async def send_photos_to_telegram(photos):
    bot = telegram.Bot(token=TOKEN)
    media = [telegram.InputMediaPhoto(open(photo, 'rb')) for photo in photos]
    try:
        await bot.send_media_group(chat_id=CHAT_ID, media=media)
    except Exception as e:
        print("Error sending photos:", e)

# Function to get the last five photos
def get_last_five_photos(folder):
    # Get all jpg files recursively
    all_photos = sorted(glob.glob(os.path.join(folder, '**/*.jpg'), recursive=True), key=os.path.getmtime, reverse=True)
    # Take the last five photos
    last_five_photos = all_photos[:7]
    return last_five_photos

# Main function
async def main():
    # Get the last five photos
    last_five_photos = get_last_five_photos(FOLDER_PATH)
    # Send the photos to Telegram
    await send_photos_to_telegram(last_five_photos)

if __name__ == "__main__":
    asyncio.run(main())
