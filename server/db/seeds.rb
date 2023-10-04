# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

[
  {
    url: "https://media.discordapp.net/attachments/1158089317739155497/1158421720768712815/lmomente_Mar_9f3db3dc-3b55-4976-8b34-18ab9e22d9c1.png?ex=651c2fcc&is=651ade4c&hm=f6dabec13a9b4aa7f01708029fe37f6744d309b96a937868a607908262f17f80&=&width=1528&height=1528",
    prompt: "An AI generated image",
  },
  {
    url: "https://media.discordapp.net/attachments/1158089317739155497/1158425825155240007/lmomente_Mar_33aeff93-7138-4b4f-bca5-ee9421231df2.png?ex=651c339f&is=651ae21f&hm=88acd27bd83277d84186eb3fa8ec7457e9165b62fc7899ad3b648904d9883f8e&=&width=1528&height=1528",
    prompt: "An AI generated image",
  },
].each do |image|
  Image.create!(image)
end
