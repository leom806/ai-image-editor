<template>
  <main :style="{ backgroundImage: 'url(' + currentImage.src + ')' }">
    <section class="px-5 py-5">
      <div class="w-full flex-row justify-between items-center">
        <input
          v-model="prompt"
          :placeholder=currentImage.prompt
          class="pl-3 rounded-sm shadow w-2/3 h-12 text-gray-700 outline-none focus:placeholder:text-transparent"
        />

        <button
          @click="generate"
          class="ml-5 px-4 h-12 my-auto rounded-sm bg-gray-700 text-white"
        >
          <spinner v-if="loading" />
          Generate
        </button>
      </div>

      <div v-if="imagesHistory.length" class="mt-5 text-gray-800 text-lg">
        <hr class="w-60 border-gray-700 border-dotted"/>

        <ol class="flex-col justify-center items-center">
          <li v-for="image in imagesHistory" :key="image.src" class="w-60 h-60 mt-5">
            <img
              :src="image.src"
              alt="image.prompt"
              @click="animate($event, image)"
              class="cursor-pointer hover:opacity-90"
            />
          </li>
        </ol>
      </div>
    </section>
  </main>
</template>

<style scoped>

main {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-repeat: no-repeat;
  opacity: 85%;
  transition: background-image 900ms ease-in-out;
}

section {
  position: absolute;
  top: 4rem; left: 4rem; right: 4rem; bottom: 10rem;
  border-top: 1px solid rgba(204, 213, 226, 0.65);
  background: linear-gradient(
    120deg,
    rgba(204, 213, 226, 0.65) 0%,
    transparent 85%
  );
}

section > input {
  background: linear-gradient(
    90deg,
    rgb(55 65 81) 0%,
    whitesmoke 85%
  );
}

</style>

<script lang="ts">
import anime from 'animejs/lib/anime.es.js';

import Spinner from './Spinner.vue';

type Image = {
  src: string,
  prompt: string,
}

const images : Image[] = [
  {
    src: "https://media.discordapp.net/attachments/1158089317739155497/1158421720768712815/lmomente_Mar_9f3db3dc-3b55-4976-8b34-18ab9e22d9c1.png?ex=651c2fcc&is=651ade4c&hm=f6dabec13a9b4aa7f01708029fe37f6744d309b96a937868a607908262f17f80&=&width=1528&height=1528",
    prompt: "A AI generated image",
  }, {
    src: "https://media.discordapp.net/attachments/1158089317739155497/1158425825155240007/lmomente_Mar_33aeff93-7138-4b4f-bca5-ee9421231df2.png?ex=651c339f&is=651ae21f&hm=88acd27bd83277d84186eb3fa8ec7457e9165b62fc7899ad3b648904d9883f8e&=&width=1528&height=1528",
    prompt: "A AI generated image",
  }
]

const getImage = () => images[Math.floor(Math.random() * 2)]

export default {
  components: {
    'spinner': Spinner,
  },
  data() {
    return {
      loading: false as boolean,
      prompt: "" as string,
      currentImage: getImage() as Image,
      imagesHistory: [] as Image[],
    }
  },
  mounted() {
    fetch('http://localhost:3000/images').then((response) => {
      return response.json()
    }).then((data) => {
      this.imagesHistory = data.map((image: any) => {
        return { src: image.url, prompt: image.prompt }
      })
    })
  },
  methods: {
    changeImage() {
      this.currentImage = getImage()
      return this.currentImage
    },
    generate() {
      this.loading = true

      fetch('http://localhost:3000/images', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ image: { prompt: this.prompt }})
      }).then((response) => {
        return response.json()
      }).then((data) => {
        const newImage : Image = { src: data.url, prompt: data.prompt }
        this.currentImage = newImage
        this.imagesHistory.push(newImage)
        this.loading = false
      })
    },
    animate(event: any, image: Image) {
      this.currentImage = image

      anime({
        targets: event.target,
        translateX: 10,
        delay: anime.stagger(0)
      }).finished.then(() => {
        anime({
          targets: event.target,
          translateX: 0,
          delay: anime.stagger(0)
        });
      })
    }
  },
}

</script>
