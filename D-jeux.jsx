import React, { useState } from "react";
import "./Content.css";
import d1 from "../assets/dice-1.png";
import d2 from "../assets/dice-2.png";
import d3 from "../assets/dice-3.png";
import d4 from "../assets/dice-4.png";
import d5 from "../assets/dice-5.png";
import d6 from "../assets/dice-6.png";

export default function Content() {
  const [showImage, setShowImage] = useState(false);
  const [selectedImage, setSelectedImage] = useState(null);
  const [isSpinning, setIsSpinning] = useState(false);
  const [player1Score, setPlayer1Score] = useState(0);
  const [player2Score, setPlayer2Score] = useState(0);
  const [currentPlayer, setCurrentPlayer] = useState(1);
  const [stockPlayer1Score, setStockPlayer1Score] = useState(0);
  const [stockPlayer2Score, setStockPlayer2Score] = useState(0);
  const [winn, setWin] = useState(null);

  const images = [d1, d2, d3, d4, d5, d6];

  const handleWin = () => {
    setWin;
  };

  const handleClickShowImage = () => {
    setShowImage(false);
    setStockPlayer1Score(0);
    setStockPlayer2Score(0);
    setPlayer1Score(0);
    setPlayer2Score(0);
  };

  const handleAddClick = () => {
    if (currentPlayer === 1) {
      setStockPlayer1Score((prev) => {
        const score = prev + player1Score;
        if (score >= 100) {
          return 100;
        }
        return score;
      });
      setPlayer1Score(0);
      setCurrentPlayer(2);
      if (stockPlayer1Score >= 100) {
        setWin(1);
      } else {
        setWin(0);
      }
    } else {
      setStockPlayer2Score((prev) => {
        const score = prev + player2Score;
        if (score >= 100) {
          return 100;
        }
        return score;
      });
      setPlayer2Score(0);
      setCurrentPlayer(1);
      if (stockPlayer2Score >= 100) {
        setWin(2);
      } else {
        setWin(0);
      }
    }
  };

  const handleTurnClick = () => {
    setShowImage(true);
    setIsSpinning(true);
    const randomIndex = Math.floor(Math.random() * images.length);
    setSelectedImage(images[randomIndex]);

    const imageValue = randomIndex + 1;
    const isImage1 = imageValue === 1;
    if (currentPlayer === 1) {
      if (isImage1) {
        setStockPlayer1Score((prev) => {
          const score = prev + player1Score;
          if (score >= 100) {
            return 100;
          }
          return score;
        });
        setPlayer1Score(0);
        setCurrentPlayer(2);
        if (stockPlayer1Score >= 100) {
          setWin(1);
        } else {
          setWin(0);
        }
      } else {
        setPlayer1Score(player1Score + imageValue);
      }
    } else {
      if (isImage1) {
        setStockPlayer2Score((prev) => {
          const score = prev + player2Score;
          if (score >= 100) {
            return 100;
          }
          return score;
        });
        setPlayer2Score(0);
        setCurrentPlayer(1);
        if (stockPlayer2Score >= 100) {
          setWin(2);
        } else {
          setWin(0);
        }
      } else {
        setPlayer2Score(player2Score + imageValue);
      }
    }

    setTimeout(() => {
      setIsSpinning(false);
    }, 1000);
  };

  return (
    <section className="container container-center">
      <div>
        <button className="button-top button" onClick={handleClickShowImage}>
          🔄 NOUVEAU CHALLENGE
        </button>
      </div>
      <div className="id-container">
        <div className={"container-1 " + (winn === 1 ? "black" : "")}>
          <div className="joueur-top">
            <h1 className="joueur">JOUEUR 1</h1>
            <h2 className="zero">{stockPlayer1Score}</h2>
            {winn === 1 ? <div className="emoji">🎉</div> : null}
          </div>
          <div className="score-container">
            <p>SCORE ACTUEL</p>
            <h2>{player1Score}</h2>
          </div>
        </div>
        <div className={"container-2 " + (winn === 2 ? "black" : "")}>
          <div className="joueur-top">
            <h1 className="joueur">JOUEUR 2</h1>
            <h2 className="zero">{stockPlayer2Score}</h2>
            {winn === 2 ? <div className="emoji">🎉</div> : null}
          </div>
          <div className="score-container">
            <p>SCORE ACTUEL</p>
            <h2>{player2Score}</h2>
          </div>
        </div>
      </div>
      <div className="button-container">
        <button
          disabled={winn === 1 || winn === 2}
          className="button"
          onClick={handleTurnClick}
        >
          🎲 TOURNER
        </button>
        <button
          disabled={winn === 1 || winn === 2}
          className="button"
          onClick={handleAddClick}
        >
          🖨️ AJOUTER
        </button>
      </div>
      {showImage && (
        <img
          className={isSpinning ? "img spin-animation" : "spin-animation img"}
          src={selectedImage}
          alt="Random Image"
          onLoad={(e) => {
            e.target.classList.add("spin-animation");
          }}
          onAnimationEnd={(e) => {
            e.target.classList.remove("spin-animation");
          }}
        />
      )}
    </section>
  );
}
