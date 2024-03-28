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

# Message with the media
CAPTION = "⚠ Movimiento detectado"

# Function to send photos to Telegram
async def send_photos_to_telegram(photos):
    bot = telegram.Bot(token=TOKEN)
    media = [telegram.InputMediaPhoto(open(photo, 'rb')) for photo in photos]
    try:
        await bot.send_media_group(chat_id=CHAT_ID, media=media, caption=CAPTION)
    except Exception as e:
        print("Error sending photos:", e)

# Function to get the last X photos
def get_last_photos(folder):
    # Get all jpg files recursively
    all_photos = sorted(glob.glob(os.path.join(folder, '**/*.jpg'), recursive=True), key=os.path.getmtime, reverse=True)
    # Take the last X photos
    photos = all_photos[:7]
    return photos

async def main():
    photos = get_last_photos(FOLDER_PATH)
    await send_photos_to_telegram(photos)

if __name__ == "__main__":
    asyncio.run(main())

