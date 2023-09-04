import React, { useEffect, useState } from 'react'
import { AiOutlineClose, AiOutlineMenu } from 'react-icons/ai'
import { Link, useNavigate, useLocation } from 'react-router-dom'
import Login from './Login'
import UserService from '../services/userApi'

const Navbar = () => {
    const [nav, setNav] = useState(true)
    const [showModal, setShowModal] = useState(false);
    const [showPatientMenu, setShowPatientMenu] = useState(false);
    const [logBtnLbl, setLogBtnLbl] = useState('Login')

    const navigate = useNavigate();
    const location = useLocation();

    const handlePatientMenu = (item) => {
        switch (item) {
            case 'patient':
                setShowPatientMenu(!showPatientMenu)
                break;
            // Add other sub-menu items here..
            default:
                break;
        }
    }

    const handleNav = () => {
        setNav(!nav)
    }

    const validateToken = async () => {
        try {
            const resp = await UserService.AuthenticateUser()
            if (resp.status === 200) {
                return true
            } else {
                setLogBtnLbl('Login')
                return false
            }
        } catch (error) {
            setLogBtnLbl('Login')
            return false
        }
    }

    useEffect(() => {
        if (validateToken()) {
            setLogBtnLbl(<span className='text-red-500'>Logout</span>)
        }
    }, [location.pathname, showModal])

    const handleLogInOut = () => {
        if (logBtnLbl !== 'Login') {
            localStorage.removeItem('user')
            setLogBtnLbl('Login')
            navigate('/')
        } else {
            handleLoginClick()
        }
    }

    const handleLoginClick = () => {
        setShowModal(true);
    };

    return (
        <div className='fixed top-0 w-full content-center mx-auto h-20 shadow-md z-[99] text-white bg-[#011001] '>
            <div className='flex max-w-[1240px] justify-between mx-auto items-center w-full h-full pr-4 2xl:px-8'>
                <h1 className='w-full text-3xl font-bold m-4 text-[#d239b8]'>HEALTHCARE NETWORK</h1>
                <ul className={logBtnLbl === 'Login' ? 'hidden md:flex pointer-events-none' : 'hidden md:flex'}>
                    <li className='p-4 pointer-events-auto'><Link to='/'> Home</Link></li>
                    <li className='p-4'>Employees</li>
                    <li onMouseEnter={() => handlePatientMenu('patient')} onMouseLeave={() => handlePatientMenu('patient')} className="relative p-4 hover:cursor-pointer">
                        Patients
                        {showPatientMenu && (
                            <ul className="absolute w-[150px] top-full left-0 bg-white py-2 rounded shadow-lg">
                                <li>
                                    <Link to="/addpatient" className="block px-4 py-2 text-gray-900 hover:bg-gray-200">Add Patient</Link>
                                </li>
                                <li>
                                    <Link to="/searchpatient" className="block px-4 py-2 text-gray-900 hover:bg-gray-200">Search</Link>
                                </li>
                            </ul>
                        )}
                    </li>

                    <li className='p-4'>Services</li>
                    <li className='p-4 pointer-events-auto'><Link to='#'> Contact</Link></li>
                </ul>

                <span className='py-2 px-4 mr-4 rounded-full hover:cursor-pointer hover:bg-blue-100 text-blue-400 bg-slate-600'
                    onClick={handleLogInOut}>{logBtnLbl}</span>

                <div onClick={handleNav} className='block pr-4 md:hidden'>
                    {!nav ? <AiOutlineClose size={22} /> : <AiOutlineMenu size={22} />}
                </div>
                <div className='block md:hidden'>
                    <div className={!nav ? 'fixed left-0 top-0 h-full w-[65%] bg-[#011001] border-r border-gray-500 ease-in-out duration-500 ' :
                        'fixed left-[-100%] h-full top-0 bg-[#011001] ease-out duration-500'}>
                        <h1 className='w-full text-3xl font-bold m-4 text-[#d239b8]'>HEALTHCARE NETWORK</h1>
                        <ul className={logBtnLbl === 'Login' ? 'p-4 pointer-events-none' : 'p-4'}>
                            <li className='p-4 border-b border-gray-600 pointer-events-auto' onClick={handleNav} ><Link to='/'> Home</Link></li>
                            <li className='p-4 border-b border-gray-600'>Employees</li>
                            <li onClick={() => handlePatientMenu('patient')} className="relative p-4 border-b border-gray-600">
                                Patients
                                {showPatientMenu && (
                                    <ul className="absolute w-[150px] top-full left-0 bg-white py-2 rounded shadow-lg">
                                        <li onClick={handleNav}>
                                            <Link to="/addpatient" className="block px-4 py-2 text-gray-900 hover:bg-gray-200">Add Patient</Link>
                                        </li>
                                        <li>
                                            <Link to="/searchpatient" className="block px-4 py-2 text-gray-900 hover:bg-gray-200">Search</Link>
                                        </li>

                                    </ul>
                                )}
                            </li>
                            <li className='p-4 border-b border-gray-600'>Services</li>
                            <li className='p-4 pointer-events-auto'>Contact</li>
                        </ul>
                    </div>
                </div>

                {showModal && (
                    <div className="fixed z-10 inset-0 overflow-y-auto pr-4">
                        <div className="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                            <div className="fixed inset-0 transition-opacity" aria-hidden="true">
                                <div className="absolute inset-0 bg-gray-500 opacity-75"></div>
                            </div>

                            <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl 
                            transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
                                <Login closeModal={() => setShowModal(false)} />
                            </div>
                        </div>
                    </div>
                )}
            </div>
        </div>
    )
}

export default Navbar