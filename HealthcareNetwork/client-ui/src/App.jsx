import Footer from "./components/Footer"
import Hero from "./components/Hero"
import Navbar from "./components/Navbar"
import 'react-toastify/dist/ReactToastify.css';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom'
import AddPatient from './components/patients/AddPatient'
import SearchPatient from "./components/patients/SearchPatient";
import { ToastContainer, toast } from 'react-toastify';

function App() {
  return (
    <div>
       <ToastContainer position='top-center' />
      <Navbar />
      <Routes>
        <Route path="/" exact element={<Hero />}></Route>
        <Route path="/addpatient" exact element={<AddPatient />} ></Route>
        <Route path="/searchpatient" exact element={<SearchPatient />} ></Route>
      </Routes>
      <Footer />
    </div>
  )
}

export default App
