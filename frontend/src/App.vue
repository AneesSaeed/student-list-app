<script>
import StudentFormModal from './components/StudentFormModal.vue';
import { useToast } from 'vue-toastification'

export default {
  components: {StudentFormModal},
  data() {
    return {
      headers: ['MATRICULE', 'NOM', 'PRÉNOM', ''],
      columns: ['studentId', 'lastName', 'firstName'],
      students: [],
      loading: true,
      showModal: false,
      error: null,
    };
  },

  async mounted() {
    await this.loadStudents();
  },

  methods: {
    async loadStudents() {
      const API = import.meta.env.VITE_API_URL;

      try {
        const res = await fetch(`${API}/api/students`);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        this.students = await res.json();
      } catch (e) {
        this.error = e.message || 'Failed to load students.';
      } finally {
        this.loading = false;
      }
    },

    async removeStudent(studentId) {
      const toast = useToast() 
      const API = import.meta.env.VITE_API_URL;
      
      if (!confirm("Are you sure you want to remove this student?")) return;

      try {
        const res = await fetch(`${API}/api/delete/student/${studentId}`, {
          method: "DELETE",
        });
        if (!res.ok) throw new Error(`HTTP ${res.status}`);

        this.students = this.students.filter(s => s.studentId !== studentId);
        toast.success('Student removed successfully!')
      } catch (e) {
        toast.error('Failed to delete student')
      }
    },
  },
};
</script>

<template>    
    <h1 class="text-3xl md:text-4xl font-bold text-cyan-700 mb-6 border-b-4 border-cyan-600 py-2 text-center tracking-wide">
      Liste des étudiants
    </h1>
    <div class="flex justify-center  md:mt-15 mb-20 px-4">
      <div class="w-full max-w-4xl overflow-x-auto shadow-lg rounded-lg text-sm md:text-base">
        <table class="w-full table-auto rounded-lg overflow-hidden">
          <thead>
            <tr class="bg-cyan-600 text-white">
              <th v-for="(header, index) in headers" :key="index"
                    class="w-[100px] sm:w-[120px] md:w-[150px] lg:w-[200px] 
                            p-3 text-left text-sm md:text-md lg:text-lg 
                            font-semibold uppercase tracking-wider whitespace-normal"
                  >
                {{ header }}
              </th>
            </tr>
          </thead>  
          <tbody class="divide-y divide-gray-200">
            <tr
                v-for="(student, index) in students"
                :key="index"
                :class="index % 2 === 0 
                    ? 'bg-white' 
                    : 'bg-gray-50'"
                class=" hover:bg-cyan-100
                          hover:font-semibold hover:text-cyan-900
                          transition-colors"
            >
                <td
                    v-for="(column, index) in columns"
                    :key="index"
                    class="w-[100px] sm:w-[120px] md:w-[150px] lg:w-[200px] p-3 text-md break-all whitespace-normal"
                >
                    {{ student[column] }}
                </td>
                <td class="p-3 text-center">
                  <button
                    @click="removeStudent(student.studentId)"
                    class="rounded-full text-red-700 hover:bg-red-100 
                          transition-all duration-200 active:scale-95 
                          flex items-center justify-center mx-auto w-8 h-8 sm:w-9 sm:h-9 md:w-10 md:h-10"
                    aria-label="Remove student"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" 
                        viewBox="0 0 24 24" 
                        fill="none" 
                        stroke="currentColor" 
                        stroke-width="1.5" 
                        stroke-linecap="round" 
                        stroke-linejoin="round"
                        class="w-5 h-5 sm:w-6 sm:h-6">
                      <path d="M3 6h18" />
                      <path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                      <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6" />
                      <line x1="10" y1="11" x2="10" y2="17" />
                      <line x1="14" y1="11" x2="14" y2="17" />
                    </svg>
                  </button>
                </td>
            </tr>

            <tr v-if="students.length === 0">
              <td :colspan="headers.length" class="p-6 text-center text-gray-500 text-sm">
                No students found.
              </td>
            </tr>
          </tbody>
        </table>

      </div>
    </div>
    
    <!-- Button to open modal - student form-->
    <button
      @click="showModal = true"
      class="fixed right-5 
              bottom-6 md:bottom-auto md:top-18
            bg-cyan-600/90 md:bg-cyan-600 
            text-white rounded-full shadow-lg 
            hover:bg-cyan-700 transition p-4 text-sm"
    >
      + Add Student
    </button>

    <!-- Modal -->
    <StudentFormModal
      :isOpen="showModal"
      @close="showModal = false"
      @studentAdded="loadStudents"
    />
</template>
