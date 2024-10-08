import os
import threading
import customtkinter as ctk
from tkinter import filedialog, messagebox
from yt_dlp import YoutubeDL

# Fonction pour télécharger la playlist
def download_playlist():
    playlist_url = entry_url.get()
    quality_choice = quality_var.get()
    format_choice = format_var.get()
    destination_folder = entry_folder.get()
    playlist_start = entry_start.get()
    playlist_end = entry_end.get()

    # Vérifier que l'URL est fournie
    if not playlist_url:
        messagebox.showwarning("Erreur", "L'URL de la playlist est requise")
        return

    # Définir la qualité
    quality_map = {
        '1': '1080',
        '2': '720',
        '3': '480',
        '4': '360'
    }
    quality = quality_map.get(quality_choice, '1080')

    # Définir le format (vidéo ou audio)
    if format_choice == '1':
        format_option = f"bestvideo[height<={quality}]+bestaudio/best[height<={quality}]"
        output_format = "mp4"
    elif format_choice == '2':
        format_option = "bestaudio"
        output_format = "mp3"
    else:
        format_option = f"bestvideo[height<={quality}]+bestaudio/best[height<={quality}]"
        output_format = "mp4"

    # Si le dossier de destination n'est pas renseigné, utiliser le dossier courant
    if not destination_folder:
        destination_folder = os.getcwd()

    # Définir les options yt-dlp
    ydl_opts = {
        'format': format_option,
        'merge_output_format': output_format,
        'outtmpl': os.path.join(destination_folder, '%(playlist_title)s/%(title)s.%(ext)s'),
        'progress_hooks': [progress_hook],
    }

    # Ajouter l'option pour le début de la playlist si renseignée
    if playlist_start:
        ydl_opts['playliststart'] = int(playlist_start)

    # Ajouter l'option pour la fin de la playlist si renseignée
    if playlist_end:
        ydl_opts['playlistend'] = int(playlist_end)

    # Lancer le téléchargement dans un thread séparé
    threading.Thread(target=run_yt_dlp, args=(ydl_opts, playlist_url)).start()

# Fonction qui appelle yt-dlp
def run_yt_dlp(ydl_opts, playlist_url):
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download([playlist_url])

# Hook de progression pour mettre à jour la barre de progression
def progress_hook(d):
    if d['status'] == 'downloading':
        percent = d['_percent_str']
        percent = percent.replace('%', '').strip()
        try:
            progress_value = float(percent)
            progress_bar.set(progress_value / 100)
            root.update_idletasks()
        except ValueError:
            pass
    elif d['status'] == 'finished':
        progress_bar.set(1)
        #messagebox.showinfo("Succès", "Le téléchargement de la playlist est terminé !")

# Fonction pour sélectionner le dossier de destination
def browse_folder():
    folder_selected = filedialog.askdirectory()
    if folder_selected:
        entry_folder.delete(0, ctk.END)
        entry_folder.insert(0, folder_selected)

# Configuration de l'application avec customtkinter
ctk.set_appearance_mode("System")  # Modes: "System", "Dark", "Light"
ctk.set_default_color_theme("blue")  # Thèmes: "blue", "green", "dark-blue"

# Créer la fenêtre principale
root = ctk.CTk()
root.title("Téléchargeur de Playlist YouTube")
root.geometry("800x500")

# URL de la playlist
label_url = ctk.CTkLabel(root, text="URL de la playlist :", font=("Arial", 14))
label_url.grid(row=0, column=0, padx=10, pady=10, sticky="w")
entry_url = ctk.CTkEntry(root, width=400)
entry_url.grid(row=0, column=1, padx=10, pady=10)

# Qualité
label_quality = ctk.CTkLabel(root, text="Qualité maximale :", font=("Arial", 14))
label_quality.grid(row=1, column=0, padx=10, pady=10, sticky="w")

quality_var = ctk.StringVar(value='1')
quality_options = [
    ("1080p", '1'),
    ("720p", '2'),
    ("480p", '3'),
    ("360p", '4')
]
row = 1
for text, value in quality_options:
    ctk.CTkRadioButton(root, text=text, variable=quality_var, value=value).grid(row=row, column=1, sticky="w")
    row += 1

# Vidéo de début dans la playlist
label_start = ctk.CTkLabel(root, text="Télécharger à partir de la vidéo n° :", font=("Arial", 14))
label_start.grid(row=8, column=0, padx=10, pady=10, sticky="w")
entry_start = ctk.CTkEntry(root, width=50)
entry_start.grid(row=8, column=1, padx=10, pady=10, sticky="w")

# Vidéo de fin dans la playlist (optionnel)
label_end = ctk.CTkLabel(root, text="Jusqu'à la vidéo n° (optionnel) :", font=("Arial", 14))
label_end.grid(row=9, column=0, padx=10, pady=10, sticky="w")
entry_end = ctk.CTkEntry(root, width=50)
entry_end.grid(row=9, column=1, padx=10, pady=10, sticky="w")

# Format
label_format = ctk.CTkLabel(root, text="Format de téléchargement :", font=("Arial", 14))
label_format.grid(row=5, column=0, padx=10, pady=10, sticky="w")

format_var = ctk.StringVar(value='1')
format_options = [
    ("Vidéo (mp4)", '1'),
    ("Audio uniquement (mp3)", '2')
]
row = 5
for text, value in format_options:
    ctk.CTkRadioButton(root, text=text, variable=format_var, value=value).grid(row=row, column=1, sticky="w")
    row += 1

# Dossier de destination
label_folder = ctk.CTkLabel(root, text="Dossier de destination :", font=("Arial", 14))
label_folder.grid(row=7, column=0, padx=10, pady=10, sticky="w")
entry_folder = ctk.CTkEntry(root, width=400)
entry_folder.grid(row=7, column=1, padx=10, pady=10)
button_browse = ctk.CTkButton(root, text="Parcourir", command=browse_folder)
button_browse.grid(row=7, column=2, padx=10, pady=10)

# Barre de progression
progress_bar = ctk.CTkProgressBar(root, width=400)
progress_bar.grid(row=10, column=1, padx=10, pady=20)

# Bouton pour démarrer le téléchargement
button_download = ctk.CTkButton(root, text="Télécharger", command=download_playlist)
button_download.grid(row=11, column=1, padx=10, pady=20)

# Démarrer la boucle principale de l'interface
root.mainloop()
