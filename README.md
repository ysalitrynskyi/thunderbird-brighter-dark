# Thunderbird Brighter Dark

Thunderbird's dark theme makes the message list nearly black, and unread mail is marked by little more than a small green dot. This is a small stylesheet that keeps the look dark but makes the list **readable** and makes **unread mail impossible to miss**.

It was made for dark mode, but it **looks good with light themes too**: the message list gets its own calm slate look whichever theme you use.

- Cards and rows lifted from near-black to a soft slate grey
- Read mail in a clear light grey
- **Unread mail** on a blue-tinted card with a bright accent bar on the left, white bold text and a bigger unread dot
- **Brand-new mail** with a light-blue subject
- Brighter hover outline, and bold folder names when a folder has unread mail

Works with **dark and light themes**, in both **Cards view** and **Table view**. Tested on Thunderbird 157 on macOS; it should work on Linux and Windows too.

## Install

### macOS / Linux

```bash
git clone https://github.com/ysalitrynskyi/thunderbird-brighter-dark.git
cd thunderbird-brighter-dark
./install.sh
```

Then restart Thunderbird.

The script finds your default profile, copies `brighter-dark.css` into its `chrome/` folder, adds an `@import` to the top of `userChrome.css` and `userContent.css` (anything already there is kept, and a `.bak` copy is made), and turns on `toolkit.legacyUserProfileCustomizations.stylesheets` in `user.js`.

Using a different profile? Pass its folder: `./install.sh ~/Library/Thunderbird/Profiles/xxxx.default-release`

### Manual (any OS, including Windows)

1. In Thunderbird open **Help → Troubleshooting Information** and click **Open Folder** next to *Profile Folder*.
2. Create a folder called `chrome` there if it doesn't exist and copy `chrome/brighter-dark.css` into it.
3. In that `chrome` folder, create (or edit) `userChrome.css` and `userContent.css` and put this as the **first line** of each:
   ```css
   @import url("brighter-dark.css");
   ```
4. Go to **Settings → General → Config Editor**, search for `toolkit.legacyUserProfileCustomizations.stylesheets` and set it to `true`.
5. Restart Thunderbird.

## Customize the colors

All colors are variables at the top of `brighter-dark.css` in your profile's `chrome` folder:

| Variable | What it colors |
|---|---|
| `--tbd-pane-bg` | Pane background / gaps between cards |
| `--tbd-card-bg` | Card and row background |
| `--tbd-read` | Text of mail you've already read |
| `--tbd-unread` | Text of unread mail |
| `--tbd-unread-bg` | Background of unread mail |
| `--tbd-accent` | Bar on the left of unread mail |
| `--tbd-new` | Subject of brand-new mail |

Edit, save, restart Thunderbird.

## Uninstall

```bash
./uninstall.sh
```

Or delete `brighter-dark.css` and the `@import` lines from `userChrome.css` / `userContent.css`.

## Notes

- Works with Thunderbird's built-in **Dark**, **Light** and **System** themes. With a light theme, the message list keeps its slate look and stands out from the lighter interface around it.
- Thunderbird's internal class names change from time to time. If a future update breaks something, please open an issue with your Thunderbird version.

## License

MIT
