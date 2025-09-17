# ocr-translate-jp.sh

A shell script for OCR and translation of Japanese text on KDE Wayland.

## Environment

-   OS: Arch Linux
-   Desktop Environment: KDE Plasma (Wayland session)

## Dependencies

-   `spectacle`: For taking screenshots.
-   `tesseract`: The OCR engine.
-   `tesseract-data-jpn`: Japanese language data for Tesseract.
-   `translate-shell`: For command-line translation.
-   `wl-clipboard`: Provides `wl-copy` for clipboard operations on Wayland.
-   `libnotify`: Provides `notify-send` for desktop notifications.

On Arch Linux, install them with:
```sh
sudo pacman -S spectacle tesseract tesseract-data-jpn translate-shell wl-clipboard libnotify
```

## Workflow

1.  Execute the script `./ocr-translate-jp.sh`.
2.  Your cursor changes to a crosshair. Select a region of the screen containing Japanese text.
3.  The original Japanese text is automatically copied to your clipboard.
4.  A desktop notification appears with the Spanish translation of the text.
5.  Temporary files are cleaned up automatically.
