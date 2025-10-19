<script>
import axios from  "axios"

export default {
    props: {
      isOpen: Boolean, 
    },
    emits: ["close", "studenAdded"],
    data() {
        return {
            student: {
                studentId: "",
                firstName: "",
                lastName: "",
            },
            message: ""
        }
    },

    methods: {
        async registerStudent() {
            try {
                const API = import.meta.env.VITE_API_URL;
                const response = await axios.post(`${API}/api/add/student`, this.student)
                this.message = "Student registered successfully!";

                this.$emit('studentAdded')
                setTimeout(()=> this.closeModal(), 1000)
            } catch (error) {
                this.message = "Error registering student!";
                console.error(error);
            }
        },

        closeModal() {
          this.message = "";
          this.student = { studentId: "", firstName: "", lastName: "" };
          this.$emit("close")
        }
    }
}

</script>
<template>
  <div
    v-if="isOpen"
    class="fixed inset-0 flex justify-center items-start bg-black/40 backdrop-blur-[2px]"
    @click="closeModal"
  >
    <!-- Modal content -->
    <div
      class="bg-white dark:bg-gray-800
       rounded-2xl shadow-2xl w-[90%] max-w-md p-6 relative mt-[15vh]"
      @click.stop
    >
      <!-- Close button -->
      <button
        @click="closeModal"
        class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 text-xl"
      > ✕ </button>

      <h2 class="text-2xl font-semibold text-center mb-6 text-gray-800 dark:text-gray-100">
        Register Student
      </h2>

      <form @submit.prevent="registerStudent" class="space-y-4">
        <input
          v-model="student.studentId"
          type="text"
          placeholder="Matricule"
          required
          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-cyan-500 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:text-gray-100"
        />
        <input
          v-model="student.firstName"
          type="text"
          placeholder="First Name"
          required
          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-cyan-500 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:text-gray-100"
        />
        <input
          v-model="student.lastName"
          type="text"
          placeholder="Last Name"
          required
          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-cyan-500 focus:outline-none dark:bg-gray-700 dark:border-gray-600 dark:text-gray-100"
        />

        <button
          type="submit"
          class="w-full py-2 bg-cyan-600 text-white rounded-lg font-medium hover:bg-cyan-700 transition-colors"
        >
          Register
        </button>
      </form>

      <p
        v-if="message"
        :class="{
          'text-green-600 dark:text-green-400': message.includes('success'),
          'text-red-600 dark:text-red-400': message.includes('Error')
        }"
        class="mt-4 text-center font-medium"
      >
        {{ message }}
      </p>
    </div>
  </div>
</template>
