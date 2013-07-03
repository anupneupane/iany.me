usage 'gallery push|pull'
summary 'Push gallery to server or pull from server'

run do |opts, args, cmd|
  if args.first == 'pull'
    system 'rsync -rv --size-only --progress iany.me:/mnt/iany.me/shared/gallery content/'
  else
    system 'rsync -rv --size-only --progress content/gallery iany.me:/mnt/iany.me/shared/'
  end
end
