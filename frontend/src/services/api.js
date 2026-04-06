const API_BASE = import.meta.env.PUBLIC_API_URL || '/api';
  
  // Project API calls
  export async function fetchProjects() {
    return request('/projects/');
  }
  
  export async function fetchProject(id) {
    return request(`/projects/${id}/`);
  }

