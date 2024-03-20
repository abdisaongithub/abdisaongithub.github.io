import React from "react";

import './App.css'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Signin from './pages/Signin.jsx'
import Signup from './pages/Signup.jsx'
export default function App() {


  return (
<div>
  <BrowserRouter>
    <Routes>
      <Route index element={<Signin />} />
      <Route path="/signin" element={<Signin />} />
      <Route path="/signup" element={<Signup />} />
    </Routes>
  </BrowserRouter>
</div>
  )
}


