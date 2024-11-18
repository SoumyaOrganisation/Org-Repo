// Dashboard.js

import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import Footer from './Footer';
import "./login.css";
import { FaHome, FaUserCircle } from 'react-icons/fa';
import "./home.css";
import "./dashboard.css";
import Modal from './Modal'; // Import the Modal component
import { token } from './token';

const Dashboard = () => {
  // State variables
  const [selectedRole, setSelectedRole] = useState(null);
  const [showDropdown, setShowDropdown] = useState(false);
  const [isModalVisible, setModalVisible] = useState(false);
  const [selectedImage, setSelectedImage] = useState('');
  const [currentImageIndex, setCurrentImageIndex] = useState(0);
  const [imageArray, setImageArray] = useState([]);
  const navigate = useNavigate();

  const dropdownRef = useRef(null); // Reference for dropdown
  const popupRef = useRef(null);
  const [showPopup, setShowPopup] = useState(false);

  const department = localStorage.getItem('department') || ""; // Retrieve the department from localStorage
  const email = localStorage.getItem('email') || ""; // Retrieve the email from localStorage
  const name = localStorage.getItem('name') || "";
  const sessionId = localStorage.getItem('sessionId') || ""; // Retrieve the sessionId from localStorage

  // Close dropdown if clicking outside
  useEffect(() => {
    const handleClickOutside = (event) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setShowDropdown(false);
      }

      // Close popup if clicked outside
      if (popupRef.current && !popupRef.current.contains(event.target)) {
        setShowPopup(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  const handleRoleClick = (role) => {
    setSelectedRole(selectedRole === role ? null : role); // Toggle role selection
  };

  const handleLogout = async () => {
    const sessionId = localStorage.getItem('sessionId');

    if (!sessionId) {
      alert('Missing session ID.');
      return;
    }

    try {
      const response = await fetch('https://pulse.netcon.in:5000/logout', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ sessionId }),
      });

      if (response.ok) {
        const data = await response.json();
        alert(data.message); // "You have logged out successfully"

        // Clear localStorage and navigate to login
        localStorage.clear();
        navigate('/login');
      } else {
        const errorData = await response.json();
        console.error('Logout failed:', errorData.message);
        alert('Logout failed: ' + errorData.message);
      }
    } catch (error) {
      console.error('Error during logout:', error);
      alert('An error occurred during logout.');
    }
  };

  const fetchImageFromGithub = async (imageName) => {
    try {
      const response = await fetch(
        `https://api.github.com/repos/NCMPAutomation/Reports/contents/${imageName}`,
        {
          headers: {
            Authorization: `token ${token}`, // Replace with your actual token
            Accept: 'application/vnd.github.v3.raw',
          },
        }
      );
      if (response.ok) {
        return response;
      } else {
        console.error('Failed to fetch image from GitHub:', response.statusText);
        return null;
      }
    } catch (error) {
      console.error('Error fetching image:', error);
      return null;
    }
  };

  const showModal = async (repo) => {
    const { link, links } = repo;
    let imageNames = [];

    if (links && Array.isArray(links)) {
      imageNames = links;
    } else if (link) {
      imageNames = [link];
    }

    setImageArray(imageNames);
    setCurrentImageIndex(0);

    const imageName = imageNames[0];

    try {
      const response = await fetchImageFromGithub(imageName);
      if (response) {
        const imageBlob = await response.blob();
        const imageObjectURL = URL.createObjectURL(imageBlob);
        setSelectedImage(imageObjectURL);
        setModalVisible(true);
      }
    } catch (error) {
      console.error('Error fetching image:', error);
    }
  };

  const handleNextImage = async () => {
    let newIndex = currentImageIndex + 1;
    if (newIndex >= imageArray.length) {
      newIndex = 0; // Loop back to the first image
    }
    setCurrentImageIndex(newIndex);
    const imageName = imageArray[newIndex];

    try {
      const response = await fetchImageFromGithub(imageName);
      if (response) {
        const imageBlob = await response.blob();
        const imageObjectURL = URL.createObjectURL(imageBlob);
        setSelectedImage(imageObjectURL);
      }
    } catch (error) {
      console.error('Error fetching image:', error);
    }
  };

  const handlePreviousImage = async () => {
    let newIndex = currentImageIndex - 1;
    if (newIndex < 0) {
      newIndex = imageArray.length - 1; // Loop back to the last image
    }
    setCurrentImageIndex(newIndex);
    const imageName = imageArray[newIndex];

    try {
      const response = await fetchImageFromGithub(imageName);
      if (response) {
        const imageBlob = await response.blob();
        const imageObjectURL = URL.createObjectURL(imageBlob);
        setSelectedImage(imageObjectURL);
      }
    } catch (error) {
      console.error('Error fetching image:', error);
    }
  };

  const closeModal = () => {
    setModalVisible(false);
    setSelectedImage('');
    setImageArray([]);
    setCurrentImageIndex(0);
  };

  // Updated githubLinks with additional images
  const githubLinks = {
    admin: [
      { title: 'Automation Dashboard', link: 'Automation Dashboard.png' },
      {
        title: 'Internal IT - Monthly Request Handled Report Sept 2024',
        links: [
          'Internal IT - Monthly Requests Handled Report 1 - Sept 2024.png',
          'Internal IT - Monthly Requests Handled Report 2 - Sept 2024.png',
        ]
      },
      {
        title: 'PAX WiFi Report',
        links: [
          'PAX WIFI-1.png',
          'PAX WIFI-2.png',
          'PAX WIFI-3.png',
          'PAX WIFI-4.png',
        ],
      },
      {
        title: 'IVRS Report',
        links: [
          'IVRS Report July 2024-1.png',
          'IVRS Report July 2024-2.png',
          'IVRS Report July 2024-3.png',
          'IVRS Report July 2024-4.png',
        ],
      },
    ],
    manager: [
      { 
        title: 'DC IT Infra_Manager', 
        links: [
          'DC IT Infra_Manager1.png',
          'DC IT Infra_Manager2.png'
        ]
      },
      { title: 'Automation Dashboard', link: 'Automation Dashboard.png' },
      {
        title: 'Internal IT - Monthly Request Handled Report Sept 2024',
        links: [
          'Internal IT - Monthly Requests Handled Report 1 - Sept 2024.png',
          'Internal IT - Monthly Requests Handled Report 2 - Sept 2024.png',
        ]
      },
    ],
    customer: [
      { 
        title: 'DC IT Infra_Customer', 
        links:[
          'DC IT Infra_Customer-1.png',
          'DC IT Infra_Customer-2.png',
          'DC IT Infra_Customer-3.png',
        ] 
       },
       {
        title: 'Internal IT - Monthly Request Handled Report Sept 2024',
        links: [
          'Internal IT - Monthly Requests Handled Report 1 - Sept 2024.png',
          'Internal IT - Monthly Requests Handled Report 2 - Sept 2024.png',
        ]
      },
    ],
  };

  const handlePopupSubmit = async () => {
    const query = document.getElementById('query').value;
    const uname = localStorage.getItem('email'); // Automatically get the user's email from localStorage

    if (!query) {
      alert('Query cannot be empty.');
      return;
    }

    try {
      const response = await fetch('https://pulse.netcon.in:5000/submit-help-query', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ query, uname, sessionId }), // Include sessionId if necessary
      });

      if (response.ok) {
        alert('Your query has been submitted successfully!');
        setShowPopup(false);
      } else {
        alert('There was an issue submitting your query. Please try again.');
      }
    } catch (error) {
      console.error('Error submitting the query:', error);
      alert('Error submitting the query.');
    }
  };

  return (
    <div className="App">
      <div className="banner1">
        <div className="left-section">
          <img src="netcon.png" alt="Netcon Logo" className="logo" />
          <button className="home-button" onClick={() => navigate('/homepage')}>
            <FaHome />
          </button>
        </div>
        <h2 id="dash-name">
          NETCON PULSE <span className="trademark">®</span>
          <h4>Digital Operations Center</h4>
        </h2>
        <div ref={dropdownRef} className="right-section" onClick={() => setShowDropdown(!showDropdown)}>
          <button className="account-button">
            <p id="name">{name}</p>
            <FaUserCircle />
          </button>
          {showDropdown && (
            <div className="dropdown-menu">
              <p>{email}</p>
              <p>{department}</p>
              {/* <button onClick={() => navigate('/profile')}>Profile</button> */}
              <button className="help" onClick={() => setShowPopup(true)}>Help</button>
              <button className="logout" onClick={handleLogout}>
                Logout
              </button>
            </div>
          )}
        </div>
      </div>

      <div className="dashboard-container">
        <div className="role-buttons">
          <button className="role-button" onClick={() => handleRoleClick('admin')}>Admin</button>
          <button className="role-button" onClick={() => handleRoleClick('manager')}>Manager</button>
          <button className="role-button" onClick={() => handleRoleClick('customer')}>Customer</button>
        </div>
        <div className="powerbi-button-container">
          <a href="https://app.powerbi.com/" target="_blank" rel="noopener noreferrer">
            <button className="powerbi-button">Power BI</button>
          </a>
        </div>
      </div>

      <div className="github-links-container">
        {selectedRole &&
          githubLinks[selectedRole].map((repo, index) => (
            <button
              key={index}
              className="github-link-button"
              onClick={() => showModal(repo)}
            >
              {repo.title}
            </button>
          ))}
      </div>

      <Modal
        show={isModalVisible}
        image={selectedImage}
        onClose={closeModal}
        onPrev={imageArray.length > 1 ? handlePreviousImage : null}
        onNext={imageArray.length > 1 ? handleNextImage : null}
        showArrows={imageArray.length > 1}
      />

      <div>
        <button className="help-button" onClick={() => setShowPopup(true)}>Help</button>
        <div className={`overlay ${showPopup ? 'show-overlay' : ''}`}></div>
        {showPopup && (
          <div ref={popupRef} className="popup">
            <h3>Help Desk....</h3>
            <h5>Enter your query</h5>
            <textarea id="query"
              placeholder="Enter your query here..."
              maxLength="1000"
            />
            <button onClick={handlePopupSubmit}>Submit</button>
            <button onClick={() => setShowPopup(false)}>Cancel</button>
          </div>
        )}
      </div>

      <Footer />
    </div>
  );
};

export default Dashboard;
