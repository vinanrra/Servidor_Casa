from datetime import datetime
import os
import glob
import telegram
import asyncio
import sys

# Usage:
#   python send.py MEDIA_TYPE NUMBER %Y-%m-%d/%H-%M-%S
# Example:
#   python send.py jpg 7 2024-03-29/10-48-59"

# Telegram bot token
TOKEN = 'TOKEN_HERE'
# Chat ID to send the photos
CHAT_ID = 'CHAT_ID_HERE'

# Folder containing the photos
FOLDER_PATH = 'FOLDER_PATH_HERE'

# Message with the media
CAPTION = "⚠ Movimiento detectado"

media_type = sys.argv[1]

number_photos = int(sys.argv[2])

specified_time = sys.argv[3]

# Filter images based on time
def filter_images(image_paths, specified_time):
    specified_datetime = datetime.strptime(specified_time, '%Y-%m-%d/%H-%M-%S')
    filtered_images = []

    for image_path in image_paths:
        image_datetime_str = image_path.split('/')[-2] + '/' + image_path.split('/')[-1].split('.')[0]
        image_datetime = datetime.strptime(image_datetime_str, '%Y-%m-%d/%H-%M-%S')
        if image_datetime >= specified_datetime:
            filtered_images.append(image_path)

    return filtered_images

# Function to send photos to Telegram
async def send_photos_to_telegram(photos):
    bot = telegram.Bot(token=TOKEN)
    media = [telegram.InputMediaPhoto(open(photo, 'rb')) for photo in photos]
    try:
        await bot.send_message(chat_id=CHAT_ID, text=CAPTION)
        await asyncio.sleep(2)
        await bot.send_media_group(chat_id=CHAT_ID, media=media, caption=CAPTION)
    except Exception as e:
        print("Error sending photos:", e)

# Function to get the last five photos
def get_photos(folder):
    # Get all jpg files recursively
    all_photos = sorted(glob.glob(os.path.join(folder, f"**/*.{sys.argv[1]}"), recursive=True), key=os.path.getmtime, reverse=True)
    # Take the last five photos
    photos = all_photos[:number_photos]
    return photos

# Main function
async def main():
    # Get the last five photos
    photos = get_photos(FOLDER_PATH)
    # Send the photos to Telegram
    filtered_photos = filter_images(photos, specified_time)
    await send_photos_to_telegram(filtered_photos)

if __name__ == "__main__":
    asyncio.run(main())
